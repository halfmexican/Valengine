using Raylib;

const int G = 400;
const float PLAYER_JUMP_SPD = 350.0f;
const float PLAYER_HOR_SPD = 200.0f;

public struct Player {
    public Vector2 position;
    public float speed;
    public bool can_jump;
}

public struct EnvItem {
    public Rectangle rect;
    public int blocking;
    public Color color;
}

void update_player (ref Player player, EnvItem[] env_items, float delta) {
    if (is_key_down (KeyboardKey.LEFT))player.position.x -= PLAYER_HOR_SPD * delta;
    if (is_key_down (KeyboardKey.RIGHT))player.position.x += PLAYER_HOR_SPD * delta;
    if (is_key_down (KeyboardKey.SPACE) && player.can_jump) {
        player.speed = -PLAYER_JUMP_SPD;
        player.can_jump = false;
    }

    bool hit_obstacle = false;
    foreach (var ei in env_items) {
        if (ei.blocking != 0 &&
            ei.rect.x <= player.position.x &&
            ei.rect.x + ei.rect.width >= player.position.x &&
            ei.rect.y >= player.position.y &&
            ei.rect.y <= player.position.y + player.speed * delta) {
            hit_obstacle = true;
            player.speed = 0.0f;
            player.position.y = ei.rect.y;
            break;
        }
    }

    if (!hit_obstacle) {
        player.position.y += player.speed * delta;
        player.speed += G * delta;
        player.can_jump = false;
    } else {
        player.can_jump = true;
    }
}

void update_camera_combined (ref Camera2D camera, Player player, float delta, int width, int height, float vertical_offset) {
    const float min_speed = 40;
    const float min_effect_length = 10;
    const float fraction_speed = 0.8f;
    const float even_out_speed = 100.0f;

    camera.offset = Vector2 () {
        x = width / 2.0f, y = height / 2.0f + vertical_offset
    };
    Vector2 diff = Vector2 () {
        x = player.position.x - camera.target.x, y = player.position.y - camera.target.y
    };
    float length = (float) Math.sqrt (diff.x * diff.x + diff.y * diff.y); // Cast to float

    if (length > min_effect_length) {
        float speed = (float) Math.fmax (fraction_speed * length, min_speed);
        camera.target.x += diff.x * speed * delta / length;
        camera.target.y += diff.y * speed * delta / length;
    }

    // Even out on landing
    if (player.can_jump) {
        if (camera.target.y < player.position.y) {
            camera.target.y += (float) Math.fmin (player.position.y - camera.target.y, even_out_speed * delta); // Cast to float
        } else if (camera.target.y > player.position.y) {
            camera.target.y -= (float) Math.fmin (camera.target.y - player.position.y, even_out_speed * delta); // Cast to float
        }
    }
}

int main (string[] args) {
    const int screen_width = 800;
    const int screen_height = 450;

    init_window (screen_width, screen_height, "raylib [core] example - 2d camera");

    Player player = Player () {
        position = Vector2 () {
            x = 400, y = 280
        }, speed = 0, can_jump = false
    };
    EnvItem[] env_items = {
        EnvItem () {
            rect = Rectangle () {
                x = 0, y = 0, width = 1000, height = 400
            }, blocking = 0, color = LIGHTGRAY
        },
        EnvItem () {
            rect = Rectangle () {
                x = 0, y = 400, width = 1000, height = 200
            }, blocking = 1, color = GRAY
        },
        EnvItem () {
            rect = Rectangle () {
                x = 300, y = 200, width = 400, height = 10
            }, blocking = 1, color = GRAY
        },
        EnvItem () {
            rect = Rectangle () {
                x = 250, y = 300, width = 100, height = 10
            }, blocking = 1, color = GRAY
        },
        EnvItem () {
            rect = Rectangle () {
                x = 650, y = 300, width = 100, height = 10
            }, blocking = 1, color = GRAY
        }
    };

    Camera2D camera = Camera2D () {
        target = player.position, offset = Vector2 () {
            x = screen_width / 2.0f, y = screen_height / 2.0f
        }, rotation = 0.0f, zoom = 1.0f
    };

    set_target_fps (60);
    while (!window_should_close ()) {
        float delta_time = (float) get_frame_time (); // Ensure delta_time is a float

        update_player (ref player, env_items, delta_time);

        camera.zoom += get_mouse_wheel_move () * 0.05f;

        if (camera.zoom > 3.0f)camera.zoom = 3.0f;
        else if (camera.zoom < 0.25f)camera.zoom = 0.25f;

        if (is_key_pressed (KeyboardKey.R)) {
            camera.zoom = 1.0f;
            player.position = Vector2 () {
                x = 400, y = 280
            };
        }

        update_camera_combined (ref camera, player, delta_time, screen_width, screen_height, 50.0f);

        begin_drawing ();
        clear_background (LIGHTGRAY);

        begin_mode_2D (camera);

        foreach (var ei in env_items)draw_rectangle_rect (ei.rect, ei.color);

        Rectangle player_rect = { player.position.x - 20, player.position.y - 40, 40.0f, 40.0f };
        draw_rectangle_rect (player_rect, RED);
        draw_circle_vector (player.position, 5.0f, GOLD);

        end_mode_2D ();

        draw_text ("Controls:", 20, 20, 10, BLACK);
        draw_text ("- Right/Left to move", 40, 40, 10, DARKGRAY);
        draw_text ("- Space to jump", 40, 60, 10, DARKGRAY);
        draw_text ("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, DARKGRAY);

        end_drawing ();
    }

    close_window ();

    return 0;
}
