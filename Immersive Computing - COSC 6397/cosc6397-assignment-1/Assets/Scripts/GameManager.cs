using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEngine.UI;


public class GameManager : MonoBehaviour
{

    public float score = 0.0f;
    public float dogecoinPrice = 0.05f;

    public Text textPrice;
    public Text textScore;
    public GameObject prefabDogecoin;
    public Transform spawnPointsParent;

    public void IncrementScore()
    {
        this.score += dogecoinPrice;
        SetScoreText(this.score);
    }

    private void Start()
    {
        SpawnDogecoins();
    }

    private void SetPriceText(float newPrice)
    {
        textPrice.text = "Dogecoin live price: $" + newPrice.ToString();
    }

    private void SetScoreText(float newScore)
    {
        textScore.text = "Wallet: $" + newScore.ToString();
    }

    private void SpawnDogecoins()
    {
        foreach (Transform spawnPoint in spawnPointsParent)
        {
            Instantiate(prefabDogecoin, spawnPoint);
        }
    }
}
