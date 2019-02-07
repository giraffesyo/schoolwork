using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class riseAboveGround : MonoBehaviour
{

    // this value is the y point we will raise the character up to
    // should be found heuristically
    public float riseToY = -1.25f;
    private Vector3 goalTransform;
    //we want them to rise completely in a third of their alive time
    private float riseTime = childrenAppearRandomly.timeAlive / 3.0f;

    // Start is called before the first frame update
    void Start()
    {
        goalTransform = new Vector3(transform.position.x, riseToY, transform.position.z);
    }

    // Update is called once per frame
    void Update()
    {

        // set a new position based on our goal position and how much time has passed 
        transform.position = Vector3.Lerp(transform.position, goalTransform, riseTime * Time.deltaTime);
    }
}
