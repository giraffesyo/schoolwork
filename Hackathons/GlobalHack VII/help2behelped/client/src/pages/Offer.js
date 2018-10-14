import React from 'react'
import Layout from '../HOC/Layout'
import styled from 'styled-components'
import { gray, green, purple } from '../colors'
import { FaCaretUp } from 'react-icons/fa'
import { ProfileTopNav } from '../blocks/ProfileTopNav'

const Box = styled.div`
  background-color: ${gray};
  flex-basis: 1;
  border-radius: 25px;
  margin: 1rem;
  padding: 1rem;
  position: relative;
`
const Description = styled.div`
  font-size: 1rem;
  padding: 0.5rem 0;
  font-weight: 700;
  text-align: center;
  color: ${green};
`
const Purple = styled.span`
  color: ${purple};
`

class Offer extends React.PureComponent {
  render() {
    return (
      <Layout>
        <Box>
          <Description>
            Desh wants to teach you{' '}
            <Purple>
              Spanish <br />
            </Purple>
            <small>Hi! I was born in Mexico and speak fluent english.</small>
          </Description>
        </Box>

        <Box>
          <Description>
            Jake wants to do some <Purple>Shopping</Purple> for you
            <br />{' '}
            <small>
              Hey! I'm from Germany, but can only speak a little English.
            </small>
          </Description>
        </Box>

        <Box>
          <Description>
            Zach wants to help you with <Purple>Math</Purple>
            <br />{' '}
            <small>
              Hi everyone, I just moved here from Ecuador. I can speak both
              Spanish and English.{' '}
            </small>
          </Description>
        </Box>
      </Layout>
    )
  }
}

export { Offer }
