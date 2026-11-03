from collections.abc import Iterable

from build123d import *
from scipy.spatial import ConvexHull


class Hull(BasePartObject):
    def __init__(
        self,
        points: Iterable[VectorLike],
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.REPLACE,
    ):
        # Create a convex hull from the vertices
        points_array = [tuple(Vector(p)) for p in points]
        convex_hull = ConvexHull(points_array).simplices.tolist()

        # Create faces from the vertex indices
        polyhedron_faces = []
        for face_vertex_indices in convex_hull:
            corner_vertices = [points_array[i] for i in face_vertex_indices]
            polyhedron_faces.append(Face(Wire.make_polygon(corner_vertices)))

        # Create the solid from the Faces
        polyhedron = Solid(Shell(polyhedron_faces)).clean()

        super().__init__(polyhedron, rotation=rotation, align=align, mode=mode)
