[movePaymentOrderToPaid]
INSERT INTO eor_paymentorder_paid SELECT * FROM eor_paymentorder WHERE objid=$P{paymentrefid}