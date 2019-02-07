using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class hitEnemy : MonoBehaviour
{
    private AudioSource audioSource;
    private Animator animator;
    private int hitCount = 0;
    private GameObject objectHit;

    // Start is called before the first frame update
    void Start()
    {
        // get the audiosource and animator off the instance
        audioSource = GetComponent<AudioSource>();

    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        // check if the gameobject we hit has the tag enemy
        if (collision.gameObject.tag == "enemy" && hitCount == 0)
        {
            // store the gameobject that we hit
            objectHit = collision.gameObject;
            //store the animator of that object
            animator = objectHit.GetComponent<Animator>();
            // play the hit noise
            audioSource.Play();
            // play the enemy hit animation
            animator.SetTrigger("enemy_hit");
        }
        // increase hitcount (we hit something after all!)
        hitCount++;
        //now that we've hit something, destroy the koopa (they're single use)
        this.gameObject.AddComponent<destroyAfter>();

    }

}
