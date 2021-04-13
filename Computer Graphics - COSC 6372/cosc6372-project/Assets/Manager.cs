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
    [SerializeField]
    private Animator modelAnimator;
    public float normalizedAnimationTime;
    void Start()
    {
        UpdateRightHandPosition();
        ball = Instantiate(BallPrefab);

        // slow down the engine
        Time.timeScale = 1.0f;
        AnimatorStateInfo animatorStateInfo = modelAnimator.GetCurrentAnimatorStateInfo(0);
        normalizedAnimationTime = animatorStateInfo.normalizedTime;

    }

    // Update is called once per frame
    void Update()
    {
        UpdateRightHandPosition();
        AnimatorStateInfo animatorStateInfo = modelAnimator.GetCurrentAnimatorStateInfo(0);
        normalizedAnimationTime = animatorStateInfo.normalizedTime;
    }

    void UpdateRightHandPosition()
    {
        RightHandYPosition = rightHand.position.y;
    }
}

class Section
{
    public float startY;
    public float endY;
    public float durationMs;

    Section(float startY, float endY, float durationMs)
    {
        this.startY = startY;
        this.endY = endY;
        this.durationMs = durationMs;
    }
}