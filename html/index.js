let keyCode = "KeyM";  //按鍵名稱查詢 https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/keyCode

function display(bool) {
    if (bool) {
        $("#container").show();
    } else {
        $("#container").hide();
    }
    
}

display(false);

window.addEventListener('message', function (event) {
    let item = event.data;
    if (item.type === "ui") {
        if (item.status == true) {
            display(true);
        }
        else {
            display(false);
        }
        //console.log("display");
    }
    else if (item.type === "setup") {
        //console.log("setup");
        let day = new Date();
        let d = day.getDate();

        //reset row
        $("#row1").html("");
        $("#row2").html("");
        $("#row3").html("");
        $("#row4").html("");
        $("#row5").html("");

        //append row items
        $.each(item.items, function (index, value) {
            if (index < 7) {
                $("#row1").append('<td> <div class="day"> <div class="dayCount">Day ' + (index + 1) + '</div>' +
                    '<img class="rewardImg" src="./asset/img/' + value.name + '.png" title="' + value.name + '">' +
                    '<div class="count">x'+value.value+'</div>'+
                    '<button class = "sign" id="d' + (index + 1) + '"></button> </div> </td>');
            }
            else if (index < 14) {
                $("#row2").append('<td> <div class="day"> <div class="dayCount">Day ' + (index + 1) + '</div>' +
                    '<img class="rewardImg" src="./asset/img/' + value.name + '.png" title="' + value.name + '">' +
                    '<div class="count">x'+value.value+'</div>'+
                    '<button class = "sign" id="d' + (index + 1) + '"></button> </div> </td>');
            }
            else if (index < 21) {
                $("#row3").append('<td> <div class="day"> <div class="dayCount">Day ' + (index + 1) + '</div>' +
                    '<img class="rewardImg" src="./asset/img/' + value.name + '.png" title="' + value.name + '">' +
                    '<div class="count">x'+value.value+'</div>'+
                    '<button class = "sign" id="d' + (index + 1) + '"></button> </div> </td>');
            }
            else if (index < 28) {
                $("#row4").append('<td> <div class="day"> <div class="dayCount">Day ' + (index + 1) + '</div>' +
                    '<img class="rewardImg" src="./asset/img/' + value.name + '.png" title="' + value.name + '">' +
                    '<div class="count">x'+value.value+'</div>'+
                    '<button class = "sign" id="d' + (index + 1) + '"></button> </div> </td>');
            }
            else {
                $("#row5").append('<td> <div class="day"> <div class="dayCount">Day ' + (index + 1) + '</div>' +
                    '<img class="rewardImg" src="./asset/img/' + value.name + '.png" title="' + value.name + '">' +
                    '<div class="count">x'+value.value+'</div>'+
                    '<button class = "sign" id="d' + (index + 1) + '"></button> </div> </td>');
            }

            let button = document.getElementById('d' + String(index + 1));
            if (button) {
                if (index < item.lastcollectday)         //已簽到
                {
                    button.disabled = true;
                    button.textContent = "已簽到";
                }
                else if (index == item.lastcollectday && d != item.today)   //簽到
                {
                    button.disabled = false;
                    button.textContent = "簽到";
                }
                else {
                    if (index + 1 <= d) {
                        if (item.resign_ticket > 0 && index == item.lastcollectday)            //補簽
                        {
                            button.disabled = false;
                            button.textContent = "補簽到";
                        }
                        else                                //不能補簽
                        {
                            button.disabled = true;
                            button.textContent = "補簽到";
                        }
                    }
                    else                                    //不能簽到
                    {
                        button.disabled = true;
                        button.textContent = "簽到";
                    }
                }
            }
            else {
                console.log("btn set error");
            }
        });
        $("#resign").text("剩餘補簽券: "+String(item.resign_ticket));
    }
})


// if the person uses the escape key, it will exit the resource
document.onkeyup = function (event) {
    //按下ESC退出
    if (event.code == "Escape") {
        $.post('https://DailyReward/exit', JSON.stringify({}));
        return;
    }
    //按下設定的熱鍵退出
    if (event.code == keyCode) {
        if ($("#container").is(":visible")) {
            $.post('https://DailyReward/exit', JSON.stringify({}));
            return;
        }
    }
};

// $("#close").click(function () {
//     $.post('http://DailyReward/exit', JSON.stringify({}));
//     return
// })
//when the user clicks on the submit button, it will run


//選擇所有class 等於 sign 的按鈕 按下後執行下列函式

$("#allDays").on("click", ".sign", function () {
    let inputValue = $(this).attr("id");
    if (!inputValue) {
        $.post("https://DailyReward/error", JSON.stringify({
            error: "Error day output"
        }))
        return;
    }

    $(this).attr("disabled",true);
    // if there are no errors from above, we can send the data back to the original callback and hanndle it from there
    $.post('https://DailyReward/sign', JSON.stringify({
        day: inputValue.substring(1),
    }));
    return;
})


