from pathlib import Path

import pytest


@pytest.fixture()
def parts_source_dir() -> Path:
    return Path("src") / "cad" / "parts"


@pytest.fixture()
def parts_output_dir() -> Path:
    return Path("output") / "parts"


@pytest.fixture()
def logs_dir() -> Path:
    return Path("output") / "logs"
