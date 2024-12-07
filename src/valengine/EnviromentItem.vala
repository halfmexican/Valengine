using Valengine.Shapes;

namespace Valengine {
    public class EnvItem {
        public Rectangle rect;
        public bool blocking;
        public Color color;

        public EnvItem (float x, float y, float width, float height, bool blocking, Color color) {
            rect = new Rectangle (x, y, width, height);
            this.blocking = blocking;
            this.color = color;
        }
    }
}