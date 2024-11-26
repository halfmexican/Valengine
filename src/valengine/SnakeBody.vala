using Valengine;
using Valengine.Shapes;
using Valengine.Input;
using Gee;
namespace Valengine {
    public class SnakeBody : PlayerBody {
        private int direction; // 0: Right, 1: Left, 2: Down, 3: Up
        public int length;
        public Gee.List<Vector2> body_segments;
        private float move_timer;
        private const float MOVE_INTERVAL = 0.1f; 

        public SnakeBody (float x, float y) {
            base (x, y, 32, 32);
            direction = 0; // Start moving right
            length = 1;
            body_segments = new Gee.ArrayList<Vector2> ();
            body_segments.add (new Vector2 (x, y));            
            move_timer = 0.0f;
        }

        public override void update (float delta) {
            move_timer += delta;
            if (move_timer >= MOVE_INTERVAL) {
                move_timer = 0.0f;
                // Update direction based on input
                if (Keyboard.is_down (Keyboard.Key.LEFT) && direction != 0)
                    direction = 1;
                else if (Keyboard.is_down (Keyboard.Key.RIGHT) && direction != 1)
                    direction = 0;
                else if (Keyboard.is_down (Keyboard.Key.UP) && direction != 2)
                    direction = 3;
                else if (Keyboard.is_down (Keyboard.Key.DOWN) && direction != 3)
                    direction = 2;

                // Move snake
                Vector2 new_head = new Vector2 (body_segments[0].x, body_segments[0].y);
                switch (direction) {
                    case 0: new_head.x += width; break; // Right
                    case 1: new_head.x -= width; break; // Left
                    case 2: new_head.y += height; break; // Down
                    case 3: new_head.y -= height; break; // Up
                }

                // Insert new head
                body_segments.insert (0, new_head);

                // Remove tail if not growing
                if (body_segments.size > length)
                    body_segments.remove_at (body_segments.size - 1);

                // Update position
                position = new_head;
            }
        }
        public override void draw () {
            // Draw each segment of the snake
            foreach (Vector2 segment in body_segments) {
                var rect = new Rectangle (segment.x, segment.y, width, height);
                rect.draw (Color.GREEN, null, 0.0f);
            }
        }

        public void grow () {
            length += 1;
        }

        public bool check_self_collision () {
            for (int i = 1; i < body_segments.size; i++) {
                if (position.x == body_segments[i].x && position.y == body_segments[i].y)
                    return true;
            }
            return false;
        }
    }
}
