using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shatter : MonoBehaviour
{
    public GameObject ShatteredChalice;
    private GameObject goShattered;
    private MeshRenderer mRenderer;

    private bool isShattered = false;
    public AudioClip[] audioClips;
    public AudioSource audioSource;
    public bool shatter()
    {
        if (!isShattered)
        {
            mRenderer = this.gameObject.GetComponent<MeshRenderer>();

            mRenderer.enabled = false;
            // choose a random clip and play
            AudioClip randomClip = audioClips[Random.Range(0, audioClips.Length)];
            audioSource.PlayOneShot(randomClip);

            goShattered = Instantiate(ShatteredChalice, transform);
            foreach (Transform t in goShattered.transform)
            {
                Rigidbody rb = t.gameObject.AddComponent<Rigidbody>();
                rb.AddForce(new Vector3(Random.Range(-250, 1000), Random.Range(-250, 1000), Random.Range(-250, 1000)));
            }
            IEnumerator destroyCoroutine = DestroyAfter(goShattered, 5.0f);
            StartCoroutine(destroyCoroutine);
            isShattered = true;
        }
        else
        {
            unshatter();
        }
        return isShattered;
    }

    public void unshatter()
    {
        mRenderer.enabled = true;
        isShattered = false;
    }

    private IEnumerator DestroyAfter(GameObject go, float seconds)
    {
        yield return new WaitForSeconds(seconds);
        Destroy(go);
    }
}
