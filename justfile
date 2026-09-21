default: check

check: lint test

lint:
    uv run ruff check .
    uv run ruff format --check .

fmt:
    uv run ruff format .

test:
    uv run pytest
