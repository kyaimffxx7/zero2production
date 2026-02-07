{
  description = "Rust development environment for Zero to Production";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
           
            # PostgreSQL for the book's projects
            postgresql
            # Additional useful tools
            bunyan-rs  # for log formatting
            cargo-udeps
          ];

          shellHook = ''
            echo "🦀 Rust Zero to Production development environment"
            echo "Rust version: $(rustc --version)"
            echo "Cargo version: $(cargo --version)"
            echo ""
            echo "Available tools:"
            echo "  - cargo-watch: auto-rebuild on file changes"
            echo "  - cargo-tarpaulin: code coverage"
            echo "  - cargo-audit: security vulnerability scanning"
            echo "  - sqlx-cli: database migrations"
            echo "  - PostgreSQL: $(postgres --version)"
            echo ""
            echo "Set up PostgreSQL with: initdb -D ./pgdata"
          '';

          # Environment variables
          RUST_BACKTRACE = "1";
          DATABASE_URL = "postgres://postgres:password@localhost:5432/newsletter";
          IN_NIX_SHELL = "flake";
          NIX_SHELL_ENV = "rust-ztp";
        };
      }
    );
}
