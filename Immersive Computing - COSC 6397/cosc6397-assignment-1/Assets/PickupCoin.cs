using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickupCoin : MonoBehaviour
{
    private GameManager gameManager;

    private void Start()
    {
        this.gameManager = FindObjectOfType<GameManager>();
    }
    private void OnTriggerEnter(Collider other)
    {
        gameManager.IncrementScore();
        this.gameObject.SetActive(false);
    }



}
