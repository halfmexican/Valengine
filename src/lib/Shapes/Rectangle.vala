using GLib;
using Raylib;

namespace Valengine {
    namespace Shapes {
        public class Rectangle : Object {
            public Raylib.Rectangle iRectangle;
            /* Constructors */
            public Rectangle (float x, float y, float width, float height) {
                iRectangle.x = x;
                iRectangle.y = y;
                iRectangle.width = width;
                iRectangle.height = height;
            }

            /* Methods */
            /**
             * Draws the rectangle.
             */
            public void draw (Color color, Shapes.Vector2 ? origin, float ? rotation) {
                Shapes.Vector2 o;
                if (origin == null) {
                    o = new Shapes.Vector2 (0, 0);
                } else {
                    o = origin;
                }
                if (rotation == null) {
                    rotation = 0;
                }
                Raylib.draw_rectangle_pro (iRectangle, o.iVector, rotation, color.iColor);
                return;
            }

            /**
             * Draws the rectangle with a gradient.
             */
            public void draw_gradient (Color colorA, Color colorB, Color colorC, Color colorD) {
                Raylib.draw_rectangle_gradient_ext (iRectangle, colorA.iColor, colorB.iColor, colorC.iColor, colorD.iColor);
                return;
            }

            /**
             * Draws outline of the rectangle.
             */
            public void draw_outline (float thickness, Color color) {
                Raylib.draw_rectangle_lines_ext (iRectangle, thickness, color.iColor);
                return;
            }

            /**
             * Draw a rectangle with rounded corners.
             */
            public void draw_rounded (float roundness, int segments, float thickness, Color color) {
                Raylib.draw_rectangle_rounded (iRectangle, roundness, segments, color.iColor);
                return;
            }

            /**
             * Draw a rectangle outline with rounded corners.
             */
            public void draw_rounded_outline (float roundness, int segments, float thickness, Color color) {
                Raylib.draw_rectangle_rounded_lines (iRectangle, roundness, segments, thickness, color.iColor);
                return;
            }

            /* Properties */
            /**
             * X position of rectangle.
             */
            public float x {
                get {
                    return (iRectangle.x);
                }
                set {
                    iRectangle.x = value;
                }
            }
            /**
             * Y position of rectangle.
             */
            public float y {
                get {
                    return (iRectangle.y);
                }
                set {
                    iRectangle.y = value;
                }
            }
            /**
             * Width of rectangle.
             */
            public float width {
                get {
                    return (iRectangle.width);
                }
                set {
                    iRectangle.width = value;
                }
            }
            /**
             * Height of rectangle.
             */
            public float height {
                get {
                    return (iRectangle.height);
                }
                set {
                    iRectangle.height = value;
                }
            }
        }
    }
}
