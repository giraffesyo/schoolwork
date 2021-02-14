using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shatter : MonoBehaviour
{
    public GameObject shatteredChalice;
    private MeshRenderer mRenderer;
    public void shatter()
    {
        mRenderer = this.gameObject.GetComponent<MeshRenderer>();

        mRenderer.enabled = false;
        GameObject shattered = Instantiate(shatteredChalice, transform);
        foreach (Transform t in shattered.transform)
        {
            Rigidbody rb = t.gameObject.AddComponent<Rigidbody>();
            rb.AddForce(new Vector3(Random.Range(-250, 1000), Random.Range(-250, 1000), Random.Range(-250, 1000)));
        }

    }

    public void unshatter()
    {
        mRenderer.enabled = true;
        foreach (Transform t in transform)
        {
            Destroy(t);
        }
    }




}
