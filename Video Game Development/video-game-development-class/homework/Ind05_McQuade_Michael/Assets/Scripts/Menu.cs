using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
public class Menu : MonoBehaviour
{
    public bool paused = true;
    public Button QuitButton;
    public Button PlayButton;
    public GameObject MenuContainer;
    public Text CounterText;
    public LevelRestart resetBalls;

    // Start is called before the first frame update
    void Start()
    {
        QuitButton.onClick.AddListener(QuitClicked);
        PlayButton.onClick.AddListener(PlayClicked);
        Pause();
    }



    public void PlayClicked() {
        Unpause();
    }

    public void QuitClicked() {

        // exit the game
        Application.Quit();
}


    private void hideMenu() {
        MenuContainer.SetActive(false);
    }

    private void showMenu()
    {
        MenuContainer.SetActive(true);
    }

    private void Pause()
    {
        showMenu();
        CounterText.color = Color.white;
        CounterText.gameObject.SetActive(false);
        paused = true;
        Time.timeScale = 0;
    }

    private void Unpause() 
    {
        hideMenu();
        CounterText.gameObject.SetActive(true);
        CounterText.color = Color.black;
        paused = false;
        Time.timeScale = 1;
    }

    public void GameOver()
    {
        Pause();
        CounterText.gameObject.SetActive(true);
        PlayButton.GetComponentInChildren<Text>().text = "Play again?";
        PlayButton.onClick.RemoveAllListeners();
        PlayButton.onClick.AddListener(Restart);
    }
    public void Restart()
    {
        CounterText.text = "00:00";

        Unpause();
        resetBalls.Restart();
    }
}
