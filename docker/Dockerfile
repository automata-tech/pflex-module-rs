FROM rust:1.81 AS builder

WORKDIR /app

COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release || true

COPY . .

RUN cargo build --release

# ---------- Runtime stage ----------
FROM debian:bookworm-slim

WORKDIR /app

# Copy the correct binary name
COPY --from=builder /app/target/release/mock-server /usr/local/bin/mock-server

EXPOSE 10100

# Run the correct binary
CMD ["mock-server"]
