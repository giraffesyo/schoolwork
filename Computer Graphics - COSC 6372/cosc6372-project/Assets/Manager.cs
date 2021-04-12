using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Manager : MonoBehaviour
{
    // Start is called before the first frame update
    public Transform rightHand;
    [SerializeField]
    private float RightHandYPosition;
    public GameObject BallPrefab;
    private GameObject ball;
    void Start()
    {
        UpdateRightHandPosition();
        ball = Instantiate(BallPrefab);

        // slow down the engine
        Time.timeScale = 0.2f;
    }

    // Update is called once per frame
    void Update()
    {
        UpdateRightHandPosition();
    }

    void UpdateRightHandPosition()
    {
        RightHandYPosition = rightHand.position.y;
    }
}
