Alright so here you will find the libraries to use to make the site more better and animated type 

like for example i would paste the source code of some examples so u can see how it works and all

1st . this is one for scroll -> text reveal animation 

"use client"

import {
  motion,
  useReducedMotion,
  useScroll,
  useTransform,
  type MotionValue,
} from "motion/react"
import { Fragment, useRef } from "react"

const STATEMENT =
  "Animation should never make you wait. It should reveal the next idea at exactly the moment you are ready to read it."
const START_OPACITY = 0.15
const SPREAD = 0.8
const WORD_DURATION = 0.2

export interface WordProgressRange {
  start: number
  end: number
}

function getWordProgressRange(
  index: number,
  count: number,
): WordProgressRange {
  const start = count <= 1 ? 0 : (index / (count - 1)) * SPREAD

  return {
    start,
    end: Math.min(1, start + WORD_DURATION),
  }
}

export function getWordOpacity(
  progress: number,
  { start, end }: WordProgressRange,
  startOpacity = START_OPACITY,
): number {
  if (progress <= start) return startOpacity
  if (progress >= end) return 1

  const wordProgress = (progress - start) / (end - start)
  return startOpacity + (1 - startOpacity) * wordProgress
}

function Word({
  children,
  progress,
  index,
  count,
  reducedMotion,
}: {
  children: string
  progress: MotionValue<number>
  index: number
  count: number
  reducedMotion: boolean
}) {
  const range = getWordProgressRange(index, count)
  const opacity = useTransform(progress, (latest) =>
    getWordOpacity(latest, range),
  )

  return (
    <motion.span
      aria-hidden="true"
      style={reducedMotion ? undefined : { opacity }}
    >
      {children}
    </motion.span>
  )
}

export default function TextScrollWordReveal() {
  const sectionRef = useRef<HTMLElement>(null)
  const reducedMotion = useReducedMotion()
  const { scrollYProgress } = useScroll({
    target: sectionRef,
    offset: ["start start", "end end"],
  })
  const words = STATEMENT.split(" ")

  return (
    <>
      <section
        ref={sectionRef}
        className="scroll-word-reveal"
        aria-labelledby="scroll-word-reveal-heading"
      >
        <div className="scroll-word-reveal__stage">
          <div className="scroll-word-reveal__layout">
            <div className="scroll-word-reveal__progress" aria-hidden="true">
              <motion.span
                style={{ scaleY: reducedMotion ? 1 : scrollYProgress }}
              />
            </div>

            <div className="scroll-word-reveal__content">
              <p className="scroll-word-reveal__kicker">Scroll to reveal</p>
              <h1
                id="scroll-word-reveal-heading"
                className="scroll-word-reveal__heading"
                aria-label={STATEMENT}
              >
                {words.map((word, index) => (
                  <Fragment key={`${word}-${index}`}>
                    <Word
                      progress={scrollYProgress}
                      index={index}
                      count={words.length}
                      reducedMotion={Boolean(reducedMotion)}
                    >
                      {word}
                    </Word>
                    {index < words.length - 1 ? " " : null}
                  </Fragment>
                ))}
              </h1>
            </div>
          </div>
        </div>
      </section>
      <Stylesheet />
    </>
  )
}

/**
 * ==============   Styles   ================
 */

function Stylesheet() {
  return (
    <style>{`
      .scroll-word-reveal {
        width: 100%;
        min-height: 220vh;
        overflow-x: clip;
        background: var(--background);
        color: var(--foreground);
        font-family: var(--font-sans);
        -webkit-font-smoothing: antialiased;
      }

      .scroll-word-reveal__stage {
        position: sticky;
        top: 0;
        width: 100%;
        min-height: 100vh;
        display: flex;
        align-items: center;
        overflow: hidden;
        padding: 64px 48px;
      }

      .scroll-word-reveal__layout {
        width: 100%;
        max-width: 1024px;
        display: grid;
        grid-template-columns: 1px minmax(0, 1fr);
        align-items: start;
        gap: 40px;
        margin: 0 auto;
      }

      .scroll-word-reveal__progress {
        position: relative;
        width: 1px;
        height: 112px;
        overflow: hidden;
        background: var(--border);
      }

      .scroll-word-reveal__progress span {
        position: absolute;
        inset: 0;
        display: block;
        background: var(--foreground);
        transform-origin: top;
      }

      .scroll-word-reveal__content {
        max-width: 900px;
      }

      .scroll-word-reveal__kicker {
        margin: 0 0 40px;
        color: var(--foreground-feint);
        font-family: var(--font-mono);
        font-size: 11px;
        font-variation-settings: "wght" 560;
        letter-spacing: 0.16em;
        line-height: 1;
        text-transform: uppercase;
      }

      .scroll-word-reveal__heading {
        max-width: 26ch;
        margin: 0;
        color: var(--foreground);
        font-family: var(--font-sans);
        font-size: clamp(36px, 5.4vw, 56px);
        font-variation-settings: "opsz" 56, "wght" 680;
        letter-spacing: -0.045em;
        line-height: 1.08;
        text-wrap: balance;
      }

      @media (max-width: 600px) {
        .scroll-word-reveal__stage {
          padding: 48px 24px;
        }

        .scroll-word-reveal__layout {
          grid-template-columns: 1fr;
          gap: 0;
        }

        .scroll-word-reveal__progress {
          display: none;
        }

        .scroll-word-reveal__kicker {
          margin-bottom: 28px;
        }
      }
    `}</style>
  )
}



and some 
Scramble text: Hover
Text that scrambles through random characters on hover using the ScrambleText component.
which does stuff

https://animejs.com/documentation/animation/
https://www.use-scramble.dev/
use these sites for documentation

