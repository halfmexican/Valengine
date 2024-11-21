namespace Valengine {
    using Raylib;
    namespace Graphics {
        public class Image : GLib.Object {
            // Variables 
            internal Raylib.Image iImage;
            private bool is_loaded = false;

            // Constructors
            /**
             * Load image from a file.
             */
            public Image (string file) {
                this.iImage = Raylib.load_image (file);
                is_loaded = true;
            }

            /**
             * Load image from raw data.
             */
            public Image.from_raw (string file, int width, int height, int format, int header_size) {
                this.iImage = Raylib.load_image_raw (file, width, height, format, header_size);
                is_loaded = true;
            }

            /**
             * Load image from memory.
             */
            public Image.from_memory (string filename, uchar[] file_data) {
                this.iImage = Raylib.load_image_from_memory (filename, file_data);
                is_loaded = true;
            }

            // Destroyer 
            ~Image () {
                if (is_loaded) {
                    Raylib.unload_image (this.iImage);
                }
            }

            // Methods 
            /**
             * Export image to a file.
             */
            public bool export (string filename) {
                return Raylib.export_image (this.iImage, filename);
            }

            /**
             * Generate mipmaps for the image.
             */
            public void generate_mipmaps () {
                Raylib.image_mipmaps (this.iImage);
            }

            // Properties 
            /**
             * Width of the image.
             */
            public int width {
                get {
                    return this.iImage.width;
                }
            }

            /**
             * Height of the image.
             */
            public int height {
                get {
                    return this.iImage.height;
                }
            }

            /**
             * Mipmap levels of the image.
             */
            public int mipmaps {
                get {
                    return this.iImage.mipmaps;
                }
            }

            /**
             * Format of the image.
             */
            public Raylib.PixelFormat format {
                get {
                    return this.iImage.format;
                }
            }
        }
    }
}
