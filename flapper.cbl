           identification division.
           program-id. flapper.

           data division.
           working-storage section.

           copy rl-keys.

      ******************************************************************
      *        CONSTANTS
      ******************************************************************

           01 GRAVITY pic 99V99 value 0.4.
           01 SCREEN-WIDTH pic 9(4) value 800.
           01 SCREEN-HEIGHT pic 9(4) value 600.
           01 BIRD-WIDTH pic 9(4) value 30.

      ******************************************************************
      *        FLAGS
      ******************************************************************

           01 is-red pic 999 value 50.
           01 is-key-down pic 9 value 0.
           01 is-alive pic 9 value 0.
           01 is-dying pic 9 value 0.
           01 is-new-session pic 9 value 1.
           01 window-should-close pic 9 value 0.

      ******************************************************************
      *        PHYSICS
      ******************************************************************

           01 frame-time pic 9(2)V9(4) value 0.
           01 death-frames pic S999 value 0.
           01 game-clock pic 9(7) value 0.
           01 score pic 99 value 0.

           01 scroll-x pic 9(5) value 0.
           01 bird-x pic S9(5) value 300.
           01 bird-y pic S9(5) value 200.
           01 yvel pic S9(4)V9(4) value 0.
           01 xvel pic S9(4)V9(4) value 2.

           01 pipe-1-height pic S9(4).
           01 pipe-2-height pic S9(4).
           01 pipe-3-height pic S9(4).
           01 pipe-1-x pic S9(4) value 300.
           01 pipe-2-x pic S9(4) value 500.
           01 pipe-3-x pic S9(4) value 500.

      ******************************************************************
      *        RENDERING
      ******************************************************************

           01 bird-angle pic S9(4).
           01 eye-x pic S9(4).
           01 eye-y pic S9(4).
           01 beak-x  pic S9(4).
           01 beak-y pic S9(4).
           01 wing-1-x pic 9(4).
           01 wing-1-y pic 9(4).
           01 wing-2-x pic 9(4).
           01 wing-2-y pic 9(4).
           01 wing-3-x pic 9(4).
           01 wing-3-y pic 9(4).

           01 text-sin-size pic 99.

           01 pipe-1-body-upper-x pic S9(4).
           01 pipe-1-body-upper-y pic S9(4).
           01 pipe-1-head-upper-x pic S9(4).
           01 pipe-1-head-upper-y pic S9(4).

           01 pipe-1-body-lower-x pic S9(4).
           01 pipe-1-body-lower-y pic S9(4).
           01 pipe-1-head-lower-x pic S9(4).
           01 pipe-1-head-lower-y pic S9(4).


           01 pipe-2-body-upper-x pic S9(4).
           01 pipe-2-body-upper-y pic S9(4).
           01 pipe-2-head-upper-x pic S9(4).
           01 pipe-2-head-upper-y pic S9(4).

           01 pipe-2-body-lower-x pic S9(4).
           01 pipe-2-body-lower-y pic S9(4).
           01 pipe-2-head-lower-x pic S9(4).
           01 pipe-2-head-lower-y pic S9(4).


           01 pipe-3-body-upper-x pic S9(4).
           01 pipe-3-body-upper-y pic S9(4).
           01 pipe-3-head-upper-x pic S9(4).
           01 pipe-3-head-upper-y pic S9(4).

           01 pipe-3-body-lower-x pic S9(4).
           01 pipe-3-body-lower-y pic S9(4).
           01 pipe-3-head-lower-x pic S9(4).
           01 pipe-3-head-lower-y pic S9(4).

           procedure division.

           call "InitWindow" using
            by value SCREEN-WIDTH SCREEN-HEIGHT
            by reference "Flappy Cobol"
           end-call
           call "SetTargetFPS" using by value 60 end-call

           perform until window-should-close = 1
               call "WindowShouldClose"
                returning window-should-close
               end-call
               add 1 to game-clock
               perform 0400-State-Transitions
               if is-dying = 0
                   perform 0100-Handle-Input
               end-if
               if is-alive = 1 or is-dying = 1
                   perform 0200-Physics-Updates
               end-if
               if is-alive = 1
                   perform 0250-Check-Collision
               end-if
               perform 0300-Rendering
           end-perform.

           call "CloseWindow" end-call.
           stop run.

       0100-Handle-Input.
           call "b_IsKeyPressed"
            using by value rl-key-space
            returning is-key-down
           end-call.

       0200-Physics-Updates.
           call "GetFrameTime" returning frame-time end-call
           if is-key-down = 1
               set yvel to -6
           end-if

           compute yvel = yvel + GRAVITY
           compute bird-y = bird-y + yvel

           add xvel to scroll-x

           if is-alive = 1
               subtract xvel from pipe-1-x
               subtract xvel from pipe-2-x
               subtract xvel from pipe-3-x
           end-if

           if pipe-1-x < -90
               add 1 to score
               call "b_RandomRange"
                using by value 100 500
                returning pipe-1-height
               end-call
               compute pipe-1-x = pipe-3-x + 400
           end-if
           if pipe-2-x < -90
               add 1 to score
               call "b_RandomRange"
                using by value 100 500
                returning pipe-2-height
               end-call
               compute pipe-2-x = pipe-1-x + 400
           end-if.
           if pipe-3-x < -90
               add 1 to score
               call "b_RandomRange"
                using by value 100 500
                returning pipe-3-height
               end-call
               compute pipe-3-x = pipe-2-x + 400
           end-if.

       0250-Check-Collision.
           if pipe-1-x - 75 < bird-x + BIRD-WIDTH
           and pipe-1-x + 75 > bird-x
               if pipe-1-height - bird-y > 60
               or bird-y + BIRD-WIDTH - pipe-1-height > 60
                   set is-alive to 0
                   set is-dying to 1
                   set death-frames to 90
               end-if
           end-if.

           if pipe-2-x - 75 < bird-x + BIRD-WIDTH
           and pipe-2-x + 75 > bird-x
               if pipe-2-height - bird-y > 60
               or bird-y + BIRD-WIDTH - pipe-2-height > 60
                   set is-alive to 0
                   set is-dying to 1
                   set death-frames to 90
               end-if
           end-if.

           if pipe-3-x - 75 < bird-x + BIRD-WIDTH
           and pipe-3-x + 75 > bird-x
               if pipe-3-height - bird-y > 60
               or bird-y + BIRD-WIDTH - pipe-3-height > 60
                   set is-alive to 0
                   set is-dying to 1
                   set death-frames to 90
               end-if
           end-if.

           if bird-y + BIRD-WIDTH > 550
               set is-alive to 0
               set is-dying to 1
               set death-frames to 30
           end-if.

       0300-Rendering.
           call "BeginDrawing" end-call

           call "b_ClearBackground" using
            by value 120 250 250 255
           end-call

           if is-alive = 1 or is-dying = 1
               perform 0320-Render-Game
           else
               perform 0310-Render-Menu
           end-if

           call "EndDrawing" end-call.

       0310-Render-Menu.
           compute text-sin-size =
            50 + function sin(game-clock/40)*2
           if is-new-session = 1
               call "b_DrawText" using
                by reference "Press Space"
                by value 230 280
                by value text-sin-size
                by value 0 0 0 100
               end-call
           else
               perform 0321-Draw-Pipes
               perform 0311-Draw-Score-Page
           end-if

           perform 0323-Draw-World

           if is-key-down = 1
               set is-new-session to 0
               set is-alive to 1
               set score to 0
               set bird-y to 200
               set yvel to 0
               set xvel to 2
               set pipe-1-x to 800
               compute pipe-2-x = pipe-1-x + 400
               compute pipe-3-x = pipe-2-x + 400
               call "b_RandomRange"
                using by value 100 500
                giving pipe-1-height
               end-call
               call "b_RandomRange"
                using by value 100 500
                giving pipe-2-height
               end-call
               call "b_RandomRange"
                using by value 100 500
                giving pipe-3-height
               end-call
           end-if.

       0311-Draw-Score-Page.
      *    call "b_DrawRectangle" using by value
      *     325 175
      *     150 250
      *     160 135 80 255
      *    end-call.
           call "b_DrawRectangle" using by value
            325 167
            150 266
            160 135 80 255
           end-call.
           call "b_DrawRectangle" using by value
            317 175
            166 250
            160 135 80 255
           end-call.

      *    call "b_DrawRectangle" using by value
      *     330 180
      *     140 240
      *     245 235 125 255
      *    end-call.
           call "b_DrawRectangle" using by value
            330 174
            140 252
            245 235 125 255
           end-call.
           call "b_DrawRectangle" using by value
            324 180
            152 240
            245 235 125 255
           end-call.
           call "b_DrawText" using
            by reference "SCORE"
            by value 350 190 30 0 0 0 200
           call "b_DrawText" using
            by reference score
            by value 350 250 90 0 0 0 200
           end-call.
           call "b_DrawText" using
            by reference "RETRY"
            by value 350 370 30 0 0 0 200
           end-call.
           call "b_DrawText" using
            by reference "(SPACE)"
            by value 360 400 20 0 0 0 200
           end-call.

       0320-Render-Game.
           call "b_DrawText" using
            by reference score
            by value 400 140 30 0 0 0 100
           end-call
           perform 0321-Draw-Pipes
           perform 0322-Draw-Bird.
           perform 0323-Draw-World.

       0321-Draw-Pipes.
           compute pipe-1-body-upper-x = pipe-1-x - 50
           compute pipe-1-body-lower-x = pipe-1-x - 50
           compute pipe-1-head-upper-x = pipe-1-x - 75
           compute pipe-1-head-lower-x = pipe-1-x - 75

           compute pipe-1-body-upper-y = pipe-1-height - 690
           compute pipe-1-body-lower-y = pipe-1-height + 90
           compute pipe-1-head-upper-y = pipe-1-height - 90
           compute pipe-1-head-lower-y = pipe-1-height + 60

           call "b_DrawRectangle" using by value
            pipe-1-head-upper-x pipe-1-head-upper-y
            150 30
            0 255 0 255
           end-call.
           call "b_DrawRectangle" using by value
            pipe-1-head-lower-x pipe-1-head-lower-y
            150 30
            0 255 0 255
           end-call.

           call "b_DrawRectangle" using by value
            pipe-1-body-upper-x pipe-1-body-upper-y
            100 600
            0 200 0 255
           end-call.
           call "b_DrawRectangle" using by value
            pipe-1-body-lower-x pipe-1-body-lower-y
            100 600
            0 200 0 255
           end-call.


           compute pipe-2-body-upper-x = pipe-2-x - 50
           compute pipe-2-body-lower-x = pipe-2-x - 50
           compute pipe-2-head-upper-x = pipe-2-x - 75
           compute pipe-2-head-lower-x = pipe-2-x - 75

           compute pipe-2-body-upper-y = pipe-2-height - 690
           compute pipe-2-body-lower-y = pipe-2-height + 90
           compute pipe-2-head-upper-y = pipe-2-height - 90
           compute pipe-2-head-lower-y = pipe-2-height + 60

           call "b_DrawRectangle" using by value
            pipe-2-head-upper-x pipe-2-head-upper-y
            150 30
            0 255 0 255
           end-call.
           call "b_DrawRectangle" using by value
            pipe-2-head-lower-x pipe-2-head-lower-y
            150 30
            0 255 0 255
           end-call.

           call "b_DrawRectangle" using by value
            pipe-2-body-upper-x pipe-2-body-upper-y
            100 600
            0 200 0 255
           end-call.
           call "b_DrawRectangle" using by value
            pipe-2-body-lower-x pipe-2-body-lower-y
            100 600
            0 200 0 255
           end-call.


           compute pipe-3-body-upper-x = pipe-3-x - 50
           compute pipe-3-body-lower-x = pipe-3-x - 50
           compute pipe-3-head-upper-x = pipe-3-x - 75
           compute pipe-3-head-lower-x = pipe-3-x - 75

           compute pipe-3-body-upper-y = pipe-3-height - 690
           compute pipe-3-body-lower-y = pipe-3-height + 90
           compute pipe-3-head-upper-y = pipe-3-height - 90
           compute pipe-3-head-lower-y = pipe-3-height + 60

           call "b_DrawRectangle" using by value
            pipe-3-head-upper-x pipe-3-head-upper-y
            150 30
            0 255 0 255
           end-call.
           call "b_DrawRectangle" using by value
            pipe-3-head-lower-x pipe-3-head-lower-y
            150 30
            0 255 0 255
           end-call.

           call "b_DrawRectangle" using by value
            pipe-3-body-upper-x pipe-3-body-upper-y
            100 600
            0 200 0 255
           end-call.
           call "b_DrawRectangle" using by value
            pipe-3-body-lower-x pipe-3-body-lower-y
            100 600
            0 200 0 255
           end-call.

       0322-Draw-Bird.
           compute eye-x = bird-x + 15
           compute eye-y = bird-y + 5
           compute beak-x = bird-x + 26
           compute beak-y = bird-y + 8
           compute wing-1-x = bird-x + 5
           compute wing-2-x = bird-x + 11
           compute wing-3-x = bird-x + 17
           compute wing-1-y = bird-y + 17
           compute wing-2-y = bird-y + 25
           compute wing-3-y = bird-y + 17

           call "b_DrawRectangle" using by value
            bird-x bird-y
            BIRD-WIDTH BIRD-WIDTH
            50 125 200 255
           end-call
           call "b_DrawRectangle" using
            by value eye-x eye-y 5 5 0 0 0 255
           end-call
           call "b_DrawRectangle" using
            by value beak-x beak-y 12 5 255 100 0 255
           end-call.
           call "b_DrawTriangle" using by value
            wing-1-x wing-1-y
            wing-2-x wing-2-y
            wing-3-x wing-3-y
            41 102 163 255
           end-call.

       0323-Draw-World.
           call "b_DrawRectangle" using by value
            -1000 550
            2000 500
            100 200 100 255
           end-call.

       0400-State-Transitions.
           if is-dying = 1
               subtract 1 from death-frames
           end-if.
           if death-frames is negative
               set is-dying to 0
           end-if.
