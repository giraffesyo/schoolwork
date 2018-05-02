        {experts.map((currentExperts, i) => {
          if (currentExperts.length > 0) {
            return (
              <Row key={names[i]} className="mt-2">
                <Col>
                  <Area area={names[i]} experts={currentExperts} />
                </Col>
              </Row>
            )
          } else return null
        })}
