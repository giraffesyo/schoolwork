class Project {
  /*
  Areas:
  1: education
  2: health
  3: natural resources
  4: transportation
  5: traveling
  6: design
  7: technology
  */

  constructor(area) {
    this.area = area
  }

  getProjectAreaName() {
    const area = this.area
    switch (area) {
      case 1:
        return 'education'
        break
      case 2:
        return 'health'
        break
      case 3:
        return 'natural resources'
        break
      case 4:
        return 'transportation'
        break
      case 5:
        return 'traveling'
        break
      case 6:
        return 'design'
        break
      case 7:
        return 'technology'
        break
    }
  }

  getProjectArea() {
    return this.area
  }

  setProjectType(area) {
    this.area = area
  }
}
