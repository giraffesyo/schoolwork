using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spin : MonoBehaviour
{
    public int speed = 3;
    // Start is called before the first frame update
    void Start()
    {

    }

    private void FixedUpdate()
    {
        transform.Rotate(0, 50 * speed * Time.deltaTime, 0);
    }
}
