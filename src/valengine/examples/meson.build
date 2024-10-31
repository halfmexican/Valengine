# Valengine executable
if get_option('examples') == true
    executable(
        'platformer',
        dependencies: [valengine_dep],
        sources: [
            'platformer.vala',
        ],
        install: true,
    )
endif

# SnakeGame executable
if get_option('examples') == true
    executable(
        'snakegame',
        dependencies: [valengine_dep],
        sources: [
            'snake.vala',
        ],
        install: true,
    )
endif

if get_option('examples') == true
    executable(
        'pong',
        dependencies: [valengine_dep],
        sources: [
            'pong.vala',
        ],
        install: true,
    )
endif