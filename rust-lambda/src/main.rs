use std::env;
use std::future::Future;
use std::pin::Pin;

use lambda_http::{Body, lambda_runtime::Error, Request, RequestExt, Response, run, service_fn};
use serde_json::{json, Value};

type LambdaResult = Result<Response<String>, Error>;

fn build_response(status_code: u16, message: Value) -> LambdaResult {
    let response = Response::builder()
        .status(status_code)
        .header("Content-Type", "application/json")
        .body(message.to_string())
        .map_err(Box::new)?;
    Ok(response)
}

async fn echo_query(event: Request) -> LambdaResult {
    let params = event.query_string_parameters();
    let name = params.first("name").unwrap_or("world");
    let message = json!({ "message": format!("Hello, {}!", name) });
    build_response(200, message)
}

async fn echo_body(event: Request) -> LambdaResult {
    let body = event.body();
    let body_str = match body {
        Body::Text(text) => text,
        _ => return build_response(400, json!({ "error": "Invalid request body" })),
    };

    let data: Value = serde_json::from_str(body_str)?;
    let response = json!({ "message": "Received POST request", "data": data });
    build_response(200, response)
}

async fn not_found() -> LambdaResult {
    build_response(404, json!({ "error": "Not Found" }))
}

async fn hello_world() -> LambdaResult {
    build_response(200, json!({ "message": "Hello, world!" }))
}

fn route_request(event: Request) -> Pin<Box<dyn Future<Output = LambdaResult> + Send>> {
    Box::pin(async move {
        match (event.method().as_str(), event.uri().path()) {
            ("GET", "/hello") => hello_world().await,
            ("GET", "/echo") => echo_query(event).await,
            ("POST", "/echo") => echo_body(event).await,
            _ => not_found().await,
        }
    })
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    run(service_fn(route_request)).await
}
