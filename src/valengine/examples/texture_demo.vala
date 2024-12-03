using Valengine;
using Valengine.Graphics;
using Valengine.Input;
using Valengine.Shapes;

namespace Valengine {
    public class Texture2DDemo : GLib.Application {
        private Window window;
        private MainLoop loop;
        private TimeoutSource timeout;

        private const int SCREEN_WIDTH = 800;
        private const int SCREEN_HEIGHT = 600;
        private string image_path = Path.build_filename (Environment.get_current_dir (), "src/valengine/images/");

        private Texture texture;
        private Image image;

        public Texture2DDemo () {
            Object (application_id: "io.github.valengine.texture2ddemo", flags: ApplicationFlags.FLAGS_NONE);
        }

        public override void activate () {
            try {
                window = new Window (SCREEN_WIDTH, SCREEN_HEIGHT, "Valengine Texture2D Demo");
            } catch (WindowError e) {
                error ("Failed to create window: %s", e.message);
            }

            // Load image and create texture

            image = new Image (image_path + "vala.png");
            texture = new Texture.from_image (image);

            window.target_fps = 60;

            loop = new MainLoop ();
            timeout = new TimeoutSource (1);
            timeout.set_callback (main_loop);
            timeout.attach (loop.get_context ());

            loop.run ();
        }

        private bool main_loop () {
            if (window.should_close) {
                loop.quit ();
                return false;
            }

            draw ();

            return true;
        }

        private void draw () {
            window.draw (() => {
                window.clear_background (Color.BLACK);

                // Draw the texture
                Rectangle source = new Rectangle (0, 0, texture.width, texture.height);
                Rectangle destination = new Rectangle ((SCREEN_WIDTH - texture.width) / 2, (SCREEN_HEIGHT - texture.height) / 2, texture.width, texture.height);
                Vector2 origin = new Vector2 (0, 0);
                float rotation = 0.0f;
                Color tint = Color.WHITE;

                texture.draw_pro (source, destination, origin, rotation, tint);
            });
        }

        public static int main (string[] args) {
            var app = new Texture2DDemo ();
            return app.run (args);
        }
    }
}