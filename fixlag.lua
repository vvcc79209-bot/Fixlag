// Script để xoá bỏ hiệu ứng 90% skill trái võ kiếm súng và đánh thường
function removeSkillEffect() {
    let player = getPlayer(); // Lấy thông tin người chơi

    if (player.skill === 'trái võ kiếm súng') {
        player.skillEffect -= 0.9; // Xoá bỏ 90% hiệu ứng của skill trái võ kiếm súng
        console.log('Đã xoá bỏ 90% hiệu ứng của skill trái võ kiếm súng');
    } else {
        console.log('Không có hiệu ứng skill trái võ kiếm súng');
    }

    player.damage -= 0.9; // Xoá bỏ 90% sức mạnh đánh thường
    console.log('Đã xoá bỏ 90% sức mạnh đánh thường');
}

function getPlayer() {
    // Giả sử hàm này trả về thông tin người chơi
    return {
        skill: 'trái võ kiếm súng',
        skillEffect: 1, // Giả định hiệu ứng ban đầu là 100%
        damage: 100 // Giả định sức mạnh đánh ban đầu là 100
    };
}

// Gọi hàm để thực thi xoá bỏ hiệu ứng
removeSkillEffect();
