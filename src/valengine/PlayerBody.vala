using GLib;
using Valengine;
using Valengine.Shapes;

namespace Valengine {
    public abstract class PlayerBody : CharacterBody {
        protected PlayerBody (float x, float y, float width, float height) {
            base (x, y, width, height, true);
        }
    }
}
