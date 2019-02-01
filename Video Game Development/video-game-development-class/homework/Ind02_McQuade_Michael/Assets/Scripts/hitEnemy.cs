using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class hitEnemy : MonoBehaviour
{
    private AudioSource audioSource;
    private Animator animator;

    // Start is called before the first frame update
    void Start()
    {
        // get the audiosource and animator off the instance
        audioSource = GetComponent<AudioSource>();
        animator = GetComponent<Animator>();
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        // check if the gameobject we hit has the tag bullet
        if (collision.gameObject.tag == "bullet" )
        {
            Debug.Log("goomba was hit");
            // play the hit noise
            audioSource.Play();
            // play the enemy hit animation
            animator.SetTrigger("enemy_hit");
        }

    }

}
