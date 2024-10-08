namespace Valengine {
    public class Clipboard {
        private Clipboard () {
            return;
        }

        /**
         * Get clipboard text content
         */
        public static string get () {
            return (Raylib.get_clipboard_text ());
        }

        /**
         * Set clipboard text content
         */
        public static void set (string text) {
            Raylib.set_clipboard_text (text);
        }
    }
}
