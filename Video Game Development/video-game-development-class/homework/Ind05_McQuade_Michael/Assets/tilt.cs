using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class tilt : MonoBehaviour
{
    private Rigidbody rb;
    public float speed = 50;
    private void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");

        Vector3 Velocity = new Vector3(-vertical, 0, horizontal);
        Quaternion deltaRotation = Quaternion.Euler(Velocity * Time.deltaTime * speed);
        rb.MoveRotation(rb.rotation * deltaRotation);
    }
}
