using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickupCoin : MonoBehaviour
{
    public AudioClip pickupSound;
    private GameManager gameManager;

    private void Start()
    {
        this.gameManager = FindObjectOfType<GameManager>();
    }
    private void OnTriggerEnter(Collider other)
    {
        gameManager.IncrementScore();
        gameManager.GetComponent<AudioSource>().PlayOneShot(pickupSound);
        this.gameObject.SetActive(false);
    }

}
