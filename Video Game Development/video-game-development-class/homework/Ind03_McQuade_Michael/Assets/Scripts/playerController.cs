using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class playerController : MonoBehaviour
{
    // set a default, editable, speed
    public float speed = 10.0f;
    // holder for our rigidbody 2d
    private Rigidbody2D rb2d;
    // these will be set on the game object in unity
    public GameObject koopa;
    public Animator animator;
    private bool firing = false;

    private void Start()
    {
        // get the instance of the rigid body 2d for this object
        rb2d = GetComponent<Rigidbody2D>();
    }

    private void Update()
    {
        // check if we should fire
        if (ShouldFire())
        {
            // add the koopa to the playing field at our current position
            GameObject newKoopa = Instantiate(koopa, transform);
            // trigger the mouth to open
            animator.SetTrigger("OpenMouth");
        }
        else
        {
            // turn off the animation
            animator.ResetTrigger("OpenMouth");
        }

    }

    void FixedUpdate()
    {
        // get the translation for horizontal input (comes from unity input manager)
        float moveHorizontal = Input.GetAxis("Horizontal");

        // Add force to our rigidbody
        Vector2 movement = new Vector2(moveHorizontal, 0);
        // multiply movement and speed to get the force we'll apply
        rb2d.AddForce(movement * speed);
    }

    bool ShouldFire()
    {
        // "Drop Rock" axis will be greater than 0 if any fire button is pressed
        bool fireButtonHeldDown = Input.GetAxis("Drop Rock") > 0;
        if ( fireButtonHeldDown && !firing)
        {
            // when we first fire, we should make note of it so we know not to keep firing
            firing = true;
            // if space key or R2 was released, we should fire
            return true;
        } else firing &= fireButtonHeldDown; // reset firing to false when button isn't held down
        // if we're not firing and the button isnt held down we shouldn't fire 
        return false;
    }
}
