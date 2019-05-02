using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gravity : MonoBehaviour
{
    public float pullRadius = 2;
    public float pullForce = 1;
    public GameObject sphere1;
    public GameObject sphere2;
    public GameObject sphere3;
    private GameObject[] spheres;
    private void Start()
    {
        spheres = new GameObject[] { sphere1, sphere2, sphere3 };
    }

    public void FixedUpdate()
    {

        foreach (GameObject sphere in spheres ){
            // calculate direction from target to me
            Vector3 forceDirection = transform.position - sphere.transform.position;

            // apply force on target towards me
            sphere.GetComponent<Rigidbody>().AddForce(forceDirection.normalized * pullForce * Time.fixedDeltaTime);
        } 
    }
}
