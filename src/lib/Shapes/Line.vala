using GLib;
using Valengine;
using Valengine.Shapes;

namespace Valengine {
    namespace Shapes {
        public class Line : Object {
            private Line () {
                return;
            }

            /* Methods */
            /**
             * Draw basic line.
             */
            public static void draw (Vector2 startPosition, Vector2 endPosition, Color color) {
                Raylib.draw_line ((int) startPosition.x, (int) startPosition.y, (int) endPosition.x, (int) endPosition.y, color.iColor);
            }

            /**
             * Draw line using gl lines.
             */
            public static void draw_gl (Vector2 startPosition, Vector2 endPosition, float ? thickness, Color color) {
                if (thickness == null) {
                    Raylib.draw_line_vector (startPosition.iVector, endPosition.iVector, color.iColor);
                } else {
                    Raylib.draw_line_ext (startPosition.iVector, endPosition.iVector, thickness, color.iColor);
                }
            }

            /**
             * Draw lines sequence.
             */
            public static void draw_strip (Vector2[] points, Color color) {
                /* Create an array containing the Vector2 object's internal raylib struct (iVector) */
                /* For the future: Using a normal array rather than the GLib.Array object due to
                 * compilation failures on (stable). If the vala compilers updates there, change this
                 * to a GLib.Array object to reduce code size. */
                Raylib.Vector2[] v = new Raylib.Vector2[1];
                int vsize = 0;
                foreach (var i in points) {
                    vsize++;
                    int element = vsize - 1;
                    v.resize (vsize);
                    v[element].x = i.iVector.x;
                    v[element].y = i.iVector.y;
                }
                Raylib.draw_line_strip (v, color.iColor);
            }

            /**
             * Draw line segment cubic-bezier in-out interpolation
             */
            public static void draw_bezier (Vector2 startPosition, Vector2 endPosition, float thickness, Color color) {
                Raylib.draw_line_bezier (startPosition.iVector, endPosition.iVector, thickness, color.iColor);
            }
        }
    }
}
