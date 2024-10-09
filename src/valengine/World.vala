using Valengine;
using Valengine.Shapes;

namespace Valengine {
    public class World {
        public PlayerBody player { get; private set; }
        public List<EnvironmentItem> env_items { get; private set; }

        public World() {
            player = new PlayerBody(100, 100);
            env_items = new List<EnvironmentItem>();
        }

        public void add_environment_item(EnvironmentItem item) {
            env_items.append(item);
        }

        public void update(float delta) {
            player.update(delta, env_items);
        }

        public void draw() {
            player.draw();
            foreach (var item in env_items) {
                item.draw();
            }
        }
    }
}
