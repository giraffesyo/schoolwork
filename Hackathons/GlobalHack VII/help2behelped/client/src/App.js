import React from 'react'
import { HashRouter as Router, Switch, Route } from 'react-router-dom'
import { Home } from './pages/Home'
import { Login } from './pages/Login'
import { LoggedInHome } from './pages/LoggedInHome'
import { Offer } from './pages/Offer'
import { Settings } from './pages/Settings'
import { Search } from './pages/Search'


class App extends React.PureComponent {
  render() {
    return (
      <Router basename={process.env.PUBLIC_URL}>
        <Switch>
          <Route exact path="/search" component={Search} />
          <Route exact path="/offer" component={Offer} />
          <Route exact path="/settings" component={Settings} />
          <Route exact path="/home" component={LoggedInHome} />
          <Route exact path="/login" component={Login} />
          <Route exact path="/" component={Home} />
        </Switch>
      </Router>
    )
  }
}

export default App
