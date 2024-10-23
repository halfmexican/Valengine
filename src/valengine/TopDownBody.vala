namespace Valengine {
    public class TopDownBody : PlayerBody {
        private const float PLAYER_SPEED = 200.0f;

        public TopDownBody (float x, float y) : base (x, y, 40, 40) {
        }

        public override void update (float delta) {
            velocity = Vector2.ZERO;

            if (Keyboard.is_down (Keyboard.Key.LEFT))
                velocity.x = -PLAYER_SPEED;
            if (Keyboard.is_down (Keyboard.Key.RIGHT))
                velocity.x = PLAYER_SPEED;
            if (Keyboard.is_down (Keyboard.Key.UP))
                velocity.y = -PLAYER_SPEED;
            if (Keyboard.is_down (Keyboard.Key.DOWN))
                velocity.y = PLAYER_SPEED;

            // Normalize velocity to prevent faster diagonal movement
            if (velocity.length () > 0)
                velocity = velocity.normalize () * PLAYER_SPEED;

            // Update position
            base.update (delta);
        }

        public override void draw () {
            base.draw ();
            // Additional drawing code if needed
        }
    }
}
