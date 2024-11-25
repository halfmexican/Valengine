namespace Valengine {
    using Raylib;
    namespace Graphics {
        public class Texture : GLib.Object {
            /* Variables */
            internal Raylib.Texture2D iTexture;
            private bool is_loaded = false;

            /* Constructors */
            /**
             * Load texture from a file.
             */
            public Texture (string file) {
                if (Raylib.is_texture_ready (this.iTexture) == false) {
                    this.iTexture = Raylib.load_texture (file);
                    is_loaded = true;
                }
            }

            /**
             * Load texture from an image.
             */
            public Texture.from_image (Graphics.Image image) {
                this.iTexture = Raylib.load_texture_from_image (image.iImage);
                is_loaded = true;
            }

            /* Destroyer */
            ~Texture () {
                if (is_loaded) {
                    Raylib.unload_texture (this.iTexture);
                }
            }

            /* Methods */
            /**
             * Update texture with new data.
             */
            public void update (void * pixels) {
                Raylib.update_texture (this.iTexture, pixels);
            }

            /**
             * Generate mipmaps for the texture.
             */
            public void generate_mipmaps () {
                Raylib.generate_texture_mipmaps (this.iTexture);
            }

            /**
             * Draw the texture at a specific position.
             */
            public void draw (int x, int y, Color tint) {
                Raylib.draw_texture (this.iTexture, x, y, tint.iColor);
            }

            /**
             * Draw the texture at a specific position using a vector.
             */
            public void draw_from_vector (Vector2 position, Color tint) {
                Raylib.draw_texture_vector (this.iTexture, position, tint.iColor);
            }

            /**
             * Draw the texture with extended parameters.
             */
            public void draw_ext (Vector2 position, float rotation, float scale, Valengine.Color tint) {
                Raylib.draw_texture_ext (this.iTexture, position, rotation, scale, tint.iColor);
            }

            /**
             * Draw a part of the texture defined by a source rectangle.
             */
            public void draw_rectangle (Rectangle source, Shapes.Vector2 position, Color tint) {
                Raylib.draw_texture_rectangle (this.iTexture, source, position.iVector, tint.iColor);
            }

            /**
             * Draw the texture with advanced parameters.
             */
            public void draw_pro (Shapes.Rectangle source, Shapes.Rectangle destination, Shapes.Vector2 origin, float rotation, Color tint) {
                Raylib.draw_texture_pro (this.iTexture, source.iRectangle, destination.iRectangle, origin.iVector, rotation, tint.iColor);
            }

            /**
             * Draw the texture using NPatchInfo.
             */
            public void draw_npatch (NPatchInfo info, Shapes.Rectangle destination, Shapes.Vector2 origin, float rotation, Color tint) {
                Raylib.draw_texture_npatch (this.iTexture, info, destination.iRectangle, origin.iVector, rotation, tint.iColor);
            }

            /* Properties */
            /**
             * Width of the texture.
             */
            public int width {
                get {
                    return this.iTexture.width;
                }
            }

            /**
             * Height of the texture.
             */
            public int height {
                get {
                    return this.iTexture.height;
                }
            }

            /**
             * Mipmap levels of the texture.
             */
            public int mipmaps {
                get {
                    return this.iTexture.mipmaps;
                }
            }

            /**
             * Format of the texture.
             */
            public Raylib.PixelFormat format {
                get {
                    return this.iTexture.format;
                }
            }
        }
    }
}