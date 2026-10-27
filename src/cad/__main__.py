from argparse import ArgumentParser
from collections.abc import Callable
from importlib import import_module
from itertools import count as iter_count
from pathlib import Path
from typing import Any

from build123d import Compound, export_obj, export_step, export_stl, export_gltf
from build123d.topology.shape_core import Shape
from ocp_vscode import save_screenshot, show
from yaml import safe_load

EXPORT_FUNCTIONS: dict[str, Callable[[Shape, Path], None]] = {
    "obj": export_obj,
    "step": export_step,
    "stl": export_stl,
    "gltf": export_gltf,
}


def load_config(path: Path) -> dict[str, dict[str, Any]]:
    with open(path) as file:
        config = safe_load(file) or {}

    if not isinstance(config, dict):
        raise ValueError(f"Config at {path} must be a mapping of part names to definitions.")

    return config


def import_class(class_path: str) -> Any:
    module_path, class_name = class_path.rsplit(".", 1)
    module = import_module(module_path)
    return getattr(module, class_name)


def build_part(
    config: dict[str, dict[str, Any]],
    part_name: str | None,
) -> Shape:
    if part_name is None:
        raise ValueError("A part name is required.")
    if part_name not in config:
        raise ValueError(f"Unexpected part name: {part_name}")

    part_config = config[part_name]
    if not isinstance(part_config, dict):
        raise ValueError(f"Config for part '{part_name}' must be a mapping.")

    class_path = part_config.get("class")
    if not isinstance(class_path, str):
        raise ValueError(f"Part '{part_name}' must define a class path.")

    part_class = import_class(class_path)
    part = part_class(**part_config.get("config", {}))
    assert isinstance(part, Shape)
    return part


def view(
    config_path: Path,
    part_name: str,
    screenshot: bool = False,
) -> None:
    config = load_config(config_path)
    part = build_part(config, part_name)
    show(part)
    if screenshot:
        output_dir = Path() / "screenshots"
        output_dir.mkdir(parents=True, exist_ok=True)
        for index in iter_count():
            output_path = output_dir / f"{part_name}_{index:04d}.png"
            if not output_path.exists():
                break
        save_screenshot(output_path.as_posix())


def export(
    config_path: Path,
    part_name: str | None,
    format: str,
    output_dir: Path,
) -> None:
    format = format.lower()
    if format not in EXPORT_FUNCTIONS:
        raise ValueError(f"Unexpected format: {format}")

    config = load_config(config_path)
    part_counts = (
        {part_name: 1}
        if part_name
        else {
            part_name: count
            for part_name, part_config in config.items()
            if (count := int(part_config.get("export", 0)))
        }
    )
    for part_name, count in part_counts.items():
        export_function = EXPORT_FUNCTIONS[format]
        part = build_part(config, part_name)
        for index in range(count):
            output_path = output_dir / f"{part_name}-{index + 1}.{format}"
            output_dir.mkdir(parents=True, exist_ok=True)
            export_function(part, output_path)


def count(
    config_path: Path,
    part_name: str | None,
    parent_name: str | None,
):
    config = load_config(config_path)
    parent = build_part(config, parent_name)

    if not isinstance(parent, Compound):
        raise ValueError("Parent must be a Compound")

    part_config = config[part_name]
    part_class = import_class(part_config["class"])

    def recursive_count(parent: Compound) -> int:
        total = 0
        for child in parent.children:
            if isinstance(child, part_class):
                total += 1
            if isinstance(child, Compound):
                total += recursive_count(child)
        return total

    total = recursive_count(parent)
    print(f"Num. '{part_name}' in '{parent_name}': {total}")


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument(
        "--config-path",
        type=Path,
        default=Path() / "src" / "cad" / "config.yaml",
    )
    subparsers = parser.add_subparsers(required=True)

    parser_view = subparsers.add_parser("view", help="Visualize parts")
    parser_view.set_defaults(function=view)
    parser_view.add_argument("--part-name", default="main")
    parser_view.add_argument("--screenshot", action="store_true")

    parser_export = subparsers.add_parser("export", help="Export parts to file")
    parser_export.set_defaults(function=export)
    parser_export.add_argument("--part-name", default=None)
    parser_export.add_argument(
        "--format",
        type=str.lower,
        choices=EXPORT_FUNCTIONS,
        default="stl",
    )
    parser_export.add_argument("--output-dir", type=Path, default=Path() / "parts")

    parser_count = subparsers.add_parser("count", help="Count parts")
    parser_count.set_defaults(function=count)
    parser_count.add_argument("--part-name", default="main")
    parser_count.add_argument("--parent-name", default="main")

    args = vars(parser.parse_args())
    args.pop("function")(**args)
