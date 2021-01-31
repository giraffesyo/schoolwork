using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
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
        StartCoroutine(GetLiveDogecoinPrice());
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

    private IEnumerator GetLiveDogecoinPrice()
    {
        UnityWebRequest dogeWr = UnityWebRequest.Get("https://dogecoin.giraffesyo.dev/api");
        yield return dogeWr.SendWebRequest();
        if (dogeWr.result == UnityWebRequest.Result.Success)
        {
            // Show results as text
            Debug.Log(dogeWr.downloadHandler.text);
            DogecoinRequest dogeReq = JsonUtility.FromJson<DogecoinRequest>(dogeWr.downloadHandler.text);
            this.dogecoinPrice = dogeReq.price;
            SetPriceText(dogecoinPrice);
        }
        else
        {
            Debug.Log(dogeWr.error);
        }
    }
}

class DogecoinRequest
{
    public float price;
    public bool error;

}
