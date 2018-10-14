import React from 'react'
import { HashRouter as Router, Switch, Route } from 'react-router-dom'
import { Home } from './pages/Home'
import { Login } from './pages/Login'
import { LoggedInHome } from './pages/LoggedInHome'
import { Offer } from './pages/Offer'
import { Settings } from './pages/Settings'
import { Search } from './pages/Search'
import { EditProfile } from './pages/EditProfile'
import { Messages } from './pages/Messages'
import { SearchFilter } from './pages/SearchFilter'

class App extends React.PureComponent {
  render() {
    return (
      <Router basename={process.env.PUBLIC_URL}>
        <Switch>
          <Route exact path="/searchfilter" component={SearchFilter} />
          <Route exact path="/editprofile" component={EditProfile} />
          <Route exact path="/messages" component={Messages} />
          <Route exact path="/search" component={Search} />
          <Route exact path="/offer" component={Offer} />
          <Route exact path="/settings" component={Settings} />
          <Route exact path="/home" component={LoggedInHome} />
          <Route exact path="/" component={Login} />
        </Switch>
      </Router>
    )
  }
}

export default App
