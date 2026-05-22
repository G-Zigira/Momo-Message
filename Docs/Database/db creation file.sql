CREATE DATABASE IF NOT EXISTS momo_sms_db;
USE momo_sms_db;

 


CREATE TABLE transaction_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    category_code VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(255)
);


CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    momo_ref VARCHAR(50) NOT NULL UNIQUE,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20) NOT NULL,
    transaction_date DATETIME NOT NULL,
    fee DECIMAL(10,2) DEFAULT 0.00,
    raw_sms_text TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sender
        FOREIGN KEY (sender_id) REFERENCES users(user_id),

    CONSTRAINT fk_receiver
        FOREIGN KEY (receiver_id) REFERENCES users(user_id),

    CONSTRAINT fk_category
        FOREIGN KEY (category_id) REFERENCES transaction_categories(category_id)
);


CREATE TABLE system_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    message TEXT,
    source VARCHAR(100),
    extra_data JSON,
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_log_transaction
        FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);



CREATE TABLE transaction_participants (
    participant_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    user_id INT NOT NULL,
    role VARCHAR(50) NOT NULL,

    CONSTRAINT fk_tp_transaction
        FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),

    CONSTRAINT fk_tp_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);



CREATE INDEX idx_phone_number ON users(phone_number);
CREATE INDEX idx_transaction_date ON transactions(transaction_date);
CREATE INDEX idx_status ON transactions(status);





INSERT INTO users (phone_number, full_name, email, account_type) VALUES
('0788000001', 'Alice Uwase', 'alice@gmail.com', 'PERSONAL'),
('0788000002', 'Bob Mugisha', 'bob@alustudent.com', 'PERSONAL'),
('0788000003', 'Carol Ineza', 'carol@gmail.com', 'MERCHANT'),
('0788000004', 'David Niyonsaba', 'david@yahoo.com', 'AGENT'),
('0788000005', 'Eric Habimana', 'eric@outlook.com', 'PERSONAL');



INSERT INTO transaction_categories (category_name, category_code, description) VALUES
('Transfer', 'TRF', 'Money transfer'),
('Airtime', 'AIR', 'Airtime purchase'),
('Cash Out', 'CSH', 'Cash withdrawal'),
('Bill Payment', 'BIL', 'Utility payment'),
('Bank Transfer', 'BNK', 'Bank deposit');



INSERT INTO transactions
(momo_ref, sender_id, receiver_id, category_id, amount, status, transaction_date, fee, raw_sms_text)
VALUES
('MOMO001', 1, 2, 1, 5000, 'SUCCESS', NOW(), 50, 'Transferred 5000 RWF'),
('MOMO002', 2, 3, 2, 1000, 'SUCCESS', NOW(), 0, 'Bought airtime'),
('MOMO003', 3, 4, 3, 7000, 'PENDING', NOW(), 100, 'Cash withdrawal'),
('MOMO004', 4, 5, 4, 3000, 'FAILED', NOW(), 20, 'Bill payment failed'),
('MOMO005', 5, 1, 5, 10000, 'SUCCESS', NOW(), 150, 'Bank transfer');


INSERT INTO system_logs (transaction_id, event_type, message, source, extra_data) VALUES
(1, 'INFO', 'Transaction parsed successfully', 'XML Parser', JSON_OBJECT('status', 'ok')),
(2, 'INFO', 'Airtime processed', 'SMS Gateway', JSON_OBJECT('network', 'MTN')),
(3, 'WARNING', 'Pending confirmation', 'System', JSON_OBJECT('retry', true)),
(4, 'ERROR', 'Payment failed', 'Billing Engine', JSON_OBJECT('code', 500)),
(5, 'INFO', 'Bank transfer completed', 'Bank API', JSON_OBJECT('bank', 'BK'));



INSERT INTO transaction_participants (transaction_id, user_id, role) VALUES
(1, 1, 'sender'),
(1, 2, 'receiver'),
(2, 2, 'sender'),
(2, 3, 'receiver'),
(3, 3, 'sender');