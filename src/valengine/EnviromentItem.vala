using Valengine;
using Valengine.Shapes;

namespace Valengine {
    public class EnvironmentItem {
        public Rectangle rect { get; private set; }
        public bool blocking { get; private set; }

        public EnvironmentItem (float x, float y, float width, float height, bool blocking) {
            rect = new Rectangle (x, y, width, height);
            this.blocking = blocking;
        }

        public void draw () {
            rect.draw (blocking ? Color.DARK_GRAY : Color.SKY_BLUE, null, 0.0f);
        }
    }
}
