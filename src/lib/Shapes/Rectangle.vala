using GLib;
using Raylib;

namespace Valengine {
    namespace Shapes {
        public class Rectangle : Object {
            internal Raylib.Rectangle iRectangle;
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


            /*
             *
             * Copyright (c) 2024 Jose Hunter
             *
             * This program is free software: you can redistribute it and/or modify
             * it under the terms of the GNU General Public License as published by
             * the Free Software Foundation, either version 3 of the License, or
             * (at your option) any later version.
             *
             * This program is distributed in the hope that it will be useful,
             * but WITHOUT ANY WARRANTY; without even the implied warranty of
             * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
             * GNU General Public License for more details.
             *
             * You should have received a copy of the GNU General Public License
             * along with this program.  If not, see <https://www.gnu.org/licenses/>.
             */
            public bool intersects (Rectangle other) {
                return !(x + width < other.x || x > other.x + other.width ||
                         y + height < other.y || y > other.y + other.height);
            }
        }
    }
}
