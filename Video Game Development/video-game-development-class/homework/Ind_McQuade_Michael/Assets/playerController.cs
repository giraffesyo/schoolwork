using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class playerController : MonoBehaviour
{
    // set a default, editable, speed
    public float speed = 10.0f;
    private Rigidbody2D rb2d;

    private void Start()
    {
        rb2d = GetComponent<Rigidbody2D>();
    }

    void FixedUpdate()
    {
        // get the translation for horizontal input (comes from unity input manager)
        float moveHorizontal = Input.GetAxis("Horizontal");

        // Add force to our rigidbody
        Vector2 movement = new Vector2(moveHorizontal, 0);
        rb2d.AddForce(movement * speed);

    }
}
