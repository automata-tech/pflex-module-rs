ARG RUST_VERSION=1.81

FROM rust:${RUST_VERSION} AS builder

WORKDIR /app

COPY Cargo.toml Cargo.lock ./
RUN mkdir -p src/bin && echo "fn main() {}" > src/bin/mock_server.rs
RUN cargo build --release || true

COPY . .
RUN touch src/bin/mock_server.rs && cargo build --release

# ---------- Runtime stage ----------
FROM debian:bookworm-slim AS final

RUN adduser --system --no-create-home nonroot

WORKDIR /app

COPY --from=builder /app/target/release/mock-server /usr/local/bin/mock-server

EXPOSE 10100

USER nonroot

CMD ["mock-server"]
