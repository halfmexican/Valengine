using Valengine;
using Valengine.Shapes;

namespace Valengine {
    public class Environment {
        public List<EnvironmentItem> env_items;

        public Environment () {
            env_items = new List<EnvironmentItem> ();
        }

        public void add_item (EnvironmentItem item) {
            env_items.append (item);
        }

        public void draw () {
            foreach (var item in env_items) {
                item.draw ();
            }
        }
    }
}
