import React from 'react'
import styled from 'styled-components'
import { green } from '../colors'
import Color from 'color'

const Box = styled.div`
  border-radius: 5px;
  width: 15px;
  height: 10px;

  border: 1px solid
    ${Color(green)
      .darken(0.3)
      .string()};
`

const FilledGreenBox = styled(Box)`
  background-color: ${green};
`

class Checkbox extends React.PureComponent {
  render() {
    const { checked, onClick } = this.props
    return checked ? (
      <FilledGreenBox onClick={onClick} />
    ) : (
      <Box onClick={onClick} />
    )
  }
}
export { Checkbox }
