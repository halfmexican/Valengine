using GLib;
using Raylib;

namespace Valengine {
    namespace Shapes {
        public class Circle : Object {
            internal Vector2 center;

            public float x {
                get {
                    return center.x;
                }
                set {
                    center.x = value;
                }
            }

            public float y {
                get {
                    return center.y;
                }
                set {
                    center.y = value;
                }
            }

            public float radius { get; set; }

            public Circle (float x, float y, float radius) {
                this.center = new Vector2 (x, y);
                this.radius = radius;
            }

            public void draw (Color color) {
                Raylib.draw_circle_vector (this.center.iVector, this.radius, color.iColor);
            }

            public void draw_lines (Color color) {
                Raylib.draw_circle_lines ((int) this.center.x, (int) this.center.y, this.radius, color.iColor);
            }

            public void draw_gradient (Color color1, Color color2) {
                Raylib.draw_circle_gradient ((int) this.center.x, (int) this.center.y, this.radius, color1.iColor, color2.iColor);
            }

            public void draw_sector (float start_angle, float end_angle, int segments, Color color) {
                Raylib.draw_circle_sector (this.center.iVector, this.radius, start_angle, end_angle, segments, color.iColor);
            }

            public void draw_sector_lines (float start_angle, float end_angle, int segments, Color color) {
                Raylib.draw_circle_sector_lines (this.center.iVector, this.radius, start_angle, end_angle, segments, color.iColor);
            }
        }
    }
}
